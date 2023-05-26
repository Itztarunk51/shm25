// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StringInputCalculator {
    uint256 public computedValue;

    function computeStringExpression(string memory stringMathExpression) public {
        computedValue = evaluateExpression(stringMathExpression);
    }

    function evaluateExpression(string memory expression) private pure returns (uint256) {
        bytes memory expr = bytes(expression);
        uint256 result;
        uint256 numBuffer;
        uint256 sign = 1;
        bool hasNumBuffer;

        for (uint256 i = 0; i < expr.length; i++) {
            uint8 byteValue = uint8(expr[i]);

            if (byteValue >= 48 && byteValue <= 57) {
                numBuffer = numBuffer * 10 + (byteValue - 48);
                hasNumBuffer = true;
            } else if (byteValue == 43 || byteValue == 45 || byteValue == 42 || byteValue == 47) {
                if (hasNumBuffer) {
                    result = performOperation(result, numBuffer, sign);
                    numBuffer = 0;
                    hasNumBuffer = false;
                }

                if (byteValue == 43) {
                    sign = 1; // Addition
                } else if (byteValue == 45) {
                    sign = 2; // Subtraction
                } else if (byteValue == 42) {
                    sign = 3; // Multiplication
                } else if (byteValue == 47) {
                    sign = 4; // Division
                }
            } else if (byteValue == 40) {
                uint256 subExpressionStartIndex = i + 1;
                uint256 subExpressionEndIndex = findClosingParenthesis(expr, subExpressionStartIndex);
                string memory subExpression = substring(expr, subExpressionStartIndex, subExpressionEndIndex);
                numBuffer = evaluateExpression(subExpression);
                hasNumBuffer = true;
                i = subExpressionEndIndex;
            }
        }

        if (hasNumBuffer) {
            result = performOperation(result, numBuffer, sign);
        }

        return result;
    }

    function performOperation(uint256 x, uint256 y, uint256 operation) private pure returns (uint256) {
        if (operation == 1) {
            return x + y; // Addition
        } else if (operation == 2) {
            return x - y; // Subtraction
        } else if (operation == 3) {
            return x * y; // Multiplication
        } else if (operation == 4) {
            require(y != 0, "Division by zero"); // Division
            return x / y;
        }

        revert("Invalid operation");
    }

    function findClosingParenthesis(bytes memory expr, uint256 startIndex) private pure returns (uint256) {
        uint256 openParenthesisCount = 1;
        uint256 i = startIndex;

        while (i < expr.length) {
            uint8 byteValue = uint8(expr[i]);

            if (byteValue == 40) {
                openParenthesisCount++;
            } else if (byteValue == 41) {
                openParenthesisCount--;
            }

            if (openParenthesisCount == 0) {
                return i;
            }

            i++;
        }

        revert("Unbalanced parentheses");
    }

    function substring(bytes memory expr, uint256 startIndex, uint256 endIndex) private pure returns (string memory) {
        bytes memory result = new bytes(endIndex - startIndex + 1);

        for (uint256 i = startIndex; i <= endIndex; i++) {
            result[i - startIndex] = expr[i];
        }

        return string(result);
    }
}
