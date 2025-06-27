#!/usr/bin/env python3

"""
This script processes text input, classifying lines as empty, content, or separator lines,
and squashing them according to specific rules.
"""

import contextlib
import io
import re
import sys
from enum import Enum

LineType = Enum("LineType", [("EMPTY", 0), ("CONTENT", 1), ("SEPARATOR", 2)])
ParserState = Enum(
    "ParserState", [("EMPTY_AFTER_CONTENT", 2), ("CONTENT", 1), ("SEPARATOR", 3)]
)
SEPARATOR_PATTERN = r"^\s*_{30,}\s*$"
SEPARATOR_LINE = "______________________________"


# TODO: How to handle lines shorter than 30 characters?
def classify(line: str) -> LineType:
    """Classify a line as empty, content, or separator based on its content."""
    if not line.strip():
        return LineType.EMPTY
    elif bool(re.match(SEPARATOR_PATTERN, line)):
        return LineType.SEPARATOR
    else:
        return LineType.CONTENT


def squash_lines():
    """Squash lines from stdin.
    Only keep a single empty line between content lines dropping all other empty lines,
    and dropping duplicate separator lines."""

    print(SEPARATOR_LINE)
    state: ParserState = ParserState.SEPARATOR

    for raw_line in sys.stdin:
        line: str = raw_line.rstrip()
        line_type = classify(line)

        match line_type:
            case LineType.EMPTY:
                # The only empty lines we want to keep are those between content lines
                if state == ParserState.CONTENT:
                    state = ParserState.EMPTY_AFTER_CONTENT
                continue

            case LineType.CONTENT:
                if state == ParserState.EMPTY_AFTER_CONTENT:
                    print()
                print(line)
                state = ParserState.CONTENT
                continue

            case LineType.SEPARATOR:
                if state != ParserState.SEPARATOR:
                    print(SEPARATOR_LINE)
                state = ParserState.SEPARATOR
                continue

            # Otherwise throw an error in the default case
            case _:
                raise ValueError(
                    f"Unexpected line state: {state} with classification: {line_type}"
                )

    if state != ParserState.SEPARATOR:
        print(SEPARATOR_LINE)


def test_classify():
    """Test the line classification"""
    test_data = {
        LineType.EMPTY: ["", "   "],
        LineType.CONTENT: [
            "This is a content line.",
            "_____________________________",
            "This is another content line.",
        ],
        LineType.SEPARATOR: [
            "______________________________",
            "  ______________________________  ",
            "  _______________________________________  ",
        ],
    }

    for expected_type, test_values in test_data.items():
        for input_line in test_values:
            assert classify(input_line) == expected_type


def test_squash_lines():
    """Test cases: (input_pattern, expected_output_pattern)
    E=Empty, C=Content, S=Separator"""

    test_cases = [
        ("EECCECSS", "SCCECS"),
        ("CECS", "SCECS"),
        ("EEEECEEEE", "SCS"),
        ("CECECE", "SCECECS"),
        ("SSSCCC", "SCCCS"),
        ("CEEEEC", "SCECS"),
        ("SSSEEECCC", "SCCCS"),
        ("CECSEC", "SCECSCS"),
        ("EEEE", "S"),
        ("CCCC", "SCCCCS"),
        ("SSSS", "S"),
        ("CESCES", "SCSCS"),
    ]

    symbol_to_value = {
        "E": "",
        "C": "content line",
        "S": "______________________________",
    }
    type_to_symbol = {
        LineType.EMPTY: "E",
        LineType.CONTENT: "C",
        LineType.SEPARATOR: "S",
    }

    for input_pattern, expected_pattern in test_cases:
        input_lines = [symbol_to_value[char] for char in input_pattern]
        input_text = "\n".join(input_lines)

        # Capture output
        old_stdin = sys.stdin
        output_buffer = io.StringIO()
        try:
            sys.stdin = io.StringIO(input_text)
            with contextlib.redirect_stdout(output_buffer):
                squash_lines()
        finally:
            sys.stdin = old_stdin

        # Analyze output
        output_text = output_buffer.getvalue()
        output_lines = (
            output_text.rstrip("\n").split("\n") if output_text.strip() else []
        )
        actual_pattern = "".join(
            [type_to_symbol[classify(line)] for line in output_lines]
        )

        assert actual_pattern == expected_pattern, (
            f"Input: {input_pattern}, Expected: {expected_pattern}, Got: {actual_pattern}"
        )


if __name__ == "__main__":
    squash_lines()
