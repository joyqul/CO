# NCTU-CS Computer Organization – Spring 2014

Homework 1
===
>   Input two strings, where the first string is the main string while the second string is a pattern string. 
>   First reverse the main string and replace the main string as the reversed one. 
>   Secondly compare the pattern string with the new main string and check how many substrings in the new main string
match the pattern string. 
>   Two substrings can overlap. 
>   For instance, two substrings main_string[1..4] and main_string[3..6] both match the pattern string and have two characters, main_string[3] and main_string[4], in common. 
>   Then we have to count in these two substrings as matched substrings.

Homework 2
===
Lab 0
------
- Design Description
>   This lab is for practice only. 
>   It is designed to help you be familiar with the environment. You don’t need to hand in your code.
>   In this lab, you are going to design a simple marquee. 
>   Your design has to process 2 input data and output 4 different patterns. 

- Design Specification
    1. Top module: marquee
    2. Input port: clk, rst, indataA[2:0], indataB[2:0]
    3. Output port: outdata[5:0]
    4. Clock cycle is 5ns.
    5. There is an active high reset signal.
    6. Define a counter in the design. Use it to change your output pattern.
    7. Your design should be synthesizable.
    8. The corresponding pattern is as followed:
|Counter|Operation||
|:--:|:--:|:--:|
|0|OR|outdata = indataA \| indataB;|
|1|AND|outdata = indataA & indataB;|
|2|XOR|outdata = indataA ^ indataB;|
|3|MERGE|outdata = {indataA, indataB};|

>   The reset signal is sent at the falling edge of the clock. 
>   When the reset signal comes back to zero, your internal counter has to accumulate 1 at the rising edge of the clock.
>   The operation depends on the value of the counter. 
>   For example, the output is the bitwise OR of indataA and indataB when counter is 0.
        
