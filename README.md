# BayesVariableElim
A Bayes Net solved using Variable Elimination on CPTs (represented as factors). Created for CS486 (AI) Assignment 4 (Winter 2017, Kate Larson, University of Waterloo).

The variable elimination algorithm used is tailored to work with the specific Bayes Net of the assignment. However, it can easily be modified to solve different Bayes Net with minimal/few changes.

The Variable Elimination Algorithm works as follows:
  1) restrict factors in factor_list according to the evidence
  2) get product of factors in factor_list
  3) sum out hidden variables from factor product
      * sum out in order of hidden_vars
  4) normalize the factor

**To Run:**

    ruby variable_elimination.rb
