#!/bin/bash

# Initialize  variable sum_of_squares to 0
sum_of_squares=0

# Using the For Loop through 1 to 40 
for i in {1..40}
do
  square=$((i * i))
  sum_of_squares=$((sum_of_squares + square))
  
done
# Output the result
echo "The sum of the squares of the first 40 numbers is: $sum_of_squares"

