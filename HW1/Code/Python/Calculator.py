#!/usr/bin/env python3
#    Developer: Mohammad Sadegh Kalami Yazdi
#    ID: 402811068
# Support for Python 3.8+
import ast
import operator
import time

def display_welcome_message():
    welcome_message = """
    *********************************************
    *                                           *
    *      Welcome to the Basic-Calculator      *
    *                                           *
    *********************************************
    """
    print(welcome_message)
    time.sleep(0.1) 

class Calculator:
    __operators = {
        ast.Add: operator.add,
        ast.Sub: operator.sub,
        ast.Mult: operator.mul,
        ast.Div: operator.truediv,
        ast.USub: operator.neg, 
        ast.UAdd: lambda x: x
    }
    
    def __init__(self):
        pass  
    
    def calculate(self, expression):
        try:
            node = ast.parse(expression, mode='eval').body
            return self.__evaluate(node)
        except Exception as e:
            print(f"Error evaluating expression: {e}")
            return None
    
    def __evaluate(self, node):
        if isinstance(node, ast.Constant):  
            return node.value
        elif isinstance(node, ast.BinOp):  
            left = self.__evaluate(node.left)
            right = self.__evaluate(node.right)
            op_type = type(node.op)
            if op_type in self.__operators:
                op_func = self.__operators[op_type]
                return op_func(left, right)
            else:
                raise TypeError(f"Unsupported binary operator: {op_type}")
        elif isinstance(node, ast.UnaryOp):  
            operand = self.__evaluate(node.operand)
            op_type = type(node.op)
            if op_type in self.__operators:
                op_func = self.__operators[op_type]
                return op_func(operand)
            else:
                raise TypeError(f"Unsupported unary operator: {op_type}")
        else:
            raise TypeError(f"Unsupported type: {node}")
        
if __name__ == "__main__":
    display_welcome_message()
    calc = Calculator()
    while True:
        expr = input("Enter a mathematical expression (or type 'exit' to quit): ")
        if expr.lower() == 'exit':
            print("Goodbye!")
            break
        result = calc.calculate(expr)
        if result is not None:
            print(f"The result is: {result}")
