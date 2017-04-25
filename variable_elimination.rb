$max_levels = 6
$curr_id = 0

class Factor
  @factor_vals = []
  @factor_vars = []
  @factor_id = nil

  def initialize(values, vars)
    @factor_vals = values
    @factor_vars = vars
    @factor_id = $curr_id
    $curr_id += 1
  end

  def set_factor_vals(vals)
    @factor_vals = vals
  end

  def set_factor_vars(vars)
    @factor_vars = vars
  end

  attr_reader :factor_vals
  attr_reader :factor_vars
  attr_reader :factor_id

end

# --------------------------
# Helpers
# --------------------------

# Adds two multi-dim arrays of the same size/organization where
# s0[i]...[j] is added to s1[i]...[j]
def add_multi_arrays(side0, side1)
  # Get the depth of arrays (they should always be equal in this instance)
  if !(side0.is_a?(Array))
    return side0 + side1
  else
    return [add_multi_arrays(side0[0],side1[0]), add_multi_arrays(side0[1], side1[1])]
  end
end

# Multiply every value in array by given value
def mult_array(a, value)
  if !(a.is_a?(Array))
    return a * value
  else
    return [mult_array(a[0], value), mult_array(a[1], value)]
  end
end

# Add up all the values in factor
def count_values(factor)
  if !(factor.is_a?(Array))
    return factor
  else
    return count_values(factor[0]) + count_values(factor[1])
  end
end

# Divide each value by total
def divide_factor(factor, total)
  if !(factor.is_a?(Array))
    return factor.to_f / total
  else
    return [divide_factor(factor[0], total), divide_factor(factor[1], total)]
  end
end

# Normalize factor
def normalize(factor)
  # 1) Add up all the values in factor
  total = count_values(factor)
  # 2) Divide each value by the total
  divide_factor(factor, total)
end

# Moves a variable down to the end of the value list
def swap(factor, level, variable)
  # base case
  if !(factor[0][0].is_a?(Array))
    return [[factor[0][0],factor[1][0]], [factor[0][1], factor[1][1]]]
  end

  # Start swapping here
  if level >= variable
    return [swap([factor[0][0], factor[1][0]], level+1, variable), swap([factor[0][1], factor[1][1]], level+1, variable)]
  end
  return [swap(factor[0], level+1, variable), swap(factor[1], level+1, variable)]
end

# Move a variable down to the end of the vars list
def swap_vars(var_list, variable)

  var = var_list.delete_at(variable)
  var_list.push(var)
  return var_list

end

# Counts the number of common variables in variable lists
# Check to see if variable lists are in correct order
def count_common(var1, var2)
  count = 0
  var1.each do |v|
    if var2.include?(v)
      count += 1
    end
  end

  if count == 0
    puts "Error: no variables in common!"
    return nil
  end
  count
end

# Gets the depth of a factor
# ONLY works for balanced multi arrays of size 2
def get_depth(factor)
  if !(factor.is_a?(Array))
    return 0
  else
    return 1 + get_depth(factor[0])
  end
end

# Pretty Print
def pretty_print_factor(factor)

  # Print Format
  # Factor ID
  # ------------
  # ~X ~Y .... ~Z | value
  # ....
  # X Y ..... Z | value
  # ------------

  puts '------------------------'
  puts 'Factor ID: ' + factor.factor_id.to_s
  puts '------------------------'
  depth = get_depth(factor.factor_vals)

  if depth == 0
    puts factor.factor_vals.inspect
  elsif depth == 1
    puts '~' + factor.factor_vars[0].to_s + ' | ' + factor.factor_vals[0].to_s
    puts factor.factor_vars[0].to_s + ' | ' + factor.factor_vals[1].to_s
  elsif depth == 2
    puts '~' + factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' | ' + factor.factor_vals[0][0].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' | ' + factor.factor_vals[0][1].to_s
    puts factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' | ' + factor.factor_vals[1][0].to_s
    puts factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' | ' + factor.factor_vals[1][1].to_s
  elsif depth == 3
    puts '~' + factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' | ' + factor.factor_vals[0][0][0].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' | ' + factor.factor_vals[0][0][1].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' | ' + factor.factor_vals[0][1][0].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' | ' + factor.factor_vals[0][1][1].to_s
    puts factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' | ' + factor.factor_vals[1][0][0].to_s
    puts factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' | ' + factor.factor_vals[1][0][1].to_s
    puts factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' | ' + factor.factor_vals[1][1][0].to_s
    puts factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' | ' + factor.factor_vals[1][1][1].to_s
  elsif depth == 4
    puts '~' + factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' | ' + factor.factor_vals[0][0][0][0].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' | ' + factor.factor_vals[0][0][0][1].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' | ' + factor.factor_vals[0][0][1][0].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' | ' + factor.factor_vals[0][0][1][1].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' | ' + factor.factor_vals[0][1][0][0].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' | ' + factor.factor_vals[0][1][0][1].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' | ' + factor.factor_vals[0][1][1][0].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' | ' + factor.factor_vals[0][1][1][1].to_s
    puts factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' | ' + factor.factor_vals[1][0][0][0].to_s
    puts factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' | ' + factor.factor_vals[1][0][0][1].to_s
    puts factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' | ' + factor.factor_vals[1][0][1][0].to_s
    puts factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' | ' + factor.factor_vals[1][0][1][1].to_s
    puts factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' | ' + factor.factor_vals[1][1][0][0].to_s
    puts factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' | ' + factor.factor_vals[1][1][0][1].to_s
    puts factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' | ' + factor.factor_vals[1][1][1][0].to_s
    puts factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' | ' + factor.factor_vals[1][1][1][1].to_s
  else
    puts '~' + factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' ' + '~' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[0][0][0][0][0].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' ' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[0][0][0][0][1].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' ' + '~' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[0][0][0][1][0].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' ' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[0][0][0][1][1].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' ' + '~' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[0][0][1][0][0].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' ' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[0][0][1][0][1].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' ' + '~' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[0][0][1][1][0].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' ' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[0][0][1][1][1].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' ' + '~' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[0][1][0][0][0].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' ' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[0][1][0][0][1].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' ' + '~' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[0][1][0][1][0].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' ' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[0][1][0][1][1].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' ' + '~' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[0][1][1][0][0].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' ' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[0][1][1][0][1].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' ' + '~' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[0][1][1][1][0].to_s
    puts '~' + factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' ' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[0][1][1][1][1].to_s
    puts factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' ' + '~' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[1][0][0][0][0].to_s
    puts factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' ' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[1][0][0][0][1].to_s
    puts factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' ' + '~' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[1][0][0][1][0].to_s
    puts factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' ' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[1][0][0][1][1].to_s
    puts factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' ' + '~' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[1][0][1][0][0].to_s
    puts factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' ' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[1][0][1][0][1].to_s
    puts factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' ' + '~' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[1][0][1][1][0].to_s
    puts factor.factor_vars[0].to_s + ' ' + '~' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' ' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[1][0][1][1][1].to_s
    puts factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' ' + '~' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[1][1][0][0][0].to_s
    puts factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' ' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[1][1][0][0][1].to_s
    puts factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' ' + '~' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[1][1][0][1][0].to_s
    puts factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + '~' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' ' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[1][1][0][1][1].to_s
    puts factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' ' + '~' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[1][1][1][0][0].to_s
    puts factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + '~' + factor.factor_vars[3].to_s + ' ' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[1][1][1][0][1].to_s
    puts factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' ' + '~' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[1][1][1][1][0].to_s
    puts factor.factor_vars[0].to_s + ' ' + factor.factor_vars[1].to_s + ' ' + factor.factor_vars[2].to_s + ' ' + factor.factor_vars[3].to_s + ' ' + factor.factor_vars[4].to_s + ' | ' + factor.factor_vals[1][1][1][1][1].to_s
  end

  puts '------------------------'

end


# --------------------------
# Required Functions
# --------------------------

def restrict(factor, level, variable, value)

  # Make sure variable is in 0...max_levels range
  if !((0...$max_levels).include?(variable))
    return nil
  end

  # Make sure value is 0 or 1
  if value != 0 && value != 1
    return nil
  end

  if level > variable
    # Error. Level somehow went over variable
    return nil
  end

  if level == variable
    # This means we are at the variable we want to take out
    if value == 0
      return factor[0]
    else
      return factor[1]
    end
  else
    # This level stays and we check the next one
    [restrict(factor[0], level+1, variable, value), restrict(factor[1], level+1, variable, value)]
  end
end

def sumout(factor, level, variable)
  # Make sure variable is in 0...max_levels range
  if !((0...$max_levels).include?(variable))
    return nil
  end

  # Make sure level is always equal to or below variable
  if level > variable
    # Error. Level somehow went over variable
    return nil
  end

  if level == variable
    # This means we need to sum the two elem of the factor at this point
    side0 = factor[0]
    side1 = factor[1]
    return add_multi_arrays(side0, side1)
  else
    return [sumout(factor[0], level+1, variable), sumout(factor[1], level+1, variable)]
  end
end

# note level is level-1
def multiply(factor1, factor2, common_var, level)
  # Both factors must have the similar variables at the end of factor1
  # and at the beginning of factor 2 in the same order

  # Check if factor2 is just a number instead of a table
  # This occurs when a single variable CPT is restricted by itself
  # In this case, all items in factor1 are multiplied by this number
  if !(factor2.is_a?(Array))
    return mult_array(factor1, factor2)
  end

  # Base Case:
  # Factor1 is a value either 0 or 1 for last variable in factor
  # Factor2 is half of factor2, either 0 or 1 for first variable in factor
  # which matches the 0 or 1 of factor1
  # If the first item in factor1 is not an array....
  if !(factor1[0].is_a?(Array))
    return [mult_array(Marshal.load(Marshal.dump(factor2[0])), factor1[0]),
            mult_array(Marshal.load(Marshal.dump(factor2[1])), factor1[1])]
  end

  if level == 2 && common_var == 1
    return [[multiply(factor1[0][0], factor2[0], common_var, level), multiply(factor1[0][1], factor2[1], common_var, level)],
            [multiply(factor1[1][0], factor2[0], common_var, level), multiply(factor1[1][1], factor2[1], common_var,level)]]
  else
    return [multiply(factor1[0], factor2, common_var, level-1), multiply(factor1[1], factor2, common_var, level-1)]
  end
end

def inference(factor_list, query_variables, hidden_vars, evidence)

  # Steps:
  # 1) restrict factors in factor_list according to the evidence
  # 2) get product of factors in factor_list
  # 3) sum out hidden variables from factor product
  #    - sum out in order of hidden_vars
  # 4) normalize the factor

  factor_list_new = Marshal.load(Marshal.dump(factor_list))

  puts '---------------------------'
  puts 'Restricting Factors'
  puts '---------------------------'

  # 1) restrict factors in factor_list according to the evidence set
  factor_list.each_with_index do |factor, index|
    evidence.each do |k,v|
      variable_index = factor.factor_vars.find_index(k)
      if variable_index != nil
        new_factor = restrict(factor.factor_vals, 0, variable_index, v)
        factor.set_factor_vals(Marshal.load(Marshal.dump(new_factor)))
        factor.factor_vars.delete(k)
        pretty_print_factor(factor)
      end
    end
    factor_list_new[index].set_factor_vals(Marshal.load(Marshal.dump(factor.factor_vals)))
    factor_list_new[index].set_factor_vars(Marshal.load(Marshal.dump(factor.factor_vars)))
  end

  puts '---------------------------'
  puts 'Multiplying Factors'
  puts '---------------------------'

  # 2) get product of factors in factor_list
  product_list = Marshal.load(Marshal.dump(factor_list_new))
  # Check that there is more than one factor
  while product_list.length > 1
    factor1 = Marshal.load(Marshal.dump(product_list[0]))
    factor2 = Marshal.load(Marshal.dump(product_list[1]))

    # Check if second factor is just a number
    if !(factor2.factor_vals.is_a?(Array)) && factor2.factor_vals.is_a?(Numeric)
      new_factor_value = mult_array(factor1.factor_vals, factor2.factor_vals)
      product_list = product_list[1..-1]
      product_list[0].set_factor_vals(new_factor_value)
      product_list[0].set_factor_vars(factor1.factor_vars)
    else
      # Check that factors have at least one var in common
      # and that in proper order
      common_vars = count_common(factor1.factor_vars, factor2.factor_vars)
      puts 'Error: could not get common variables for factors ' + factor1.factor_id + ' and ' + factor2.factor_id if (common_vars.nil?)

      if factor1.factor_vars[-common_vars, common_vars] != factor2.factor_vars[0, common_vars]
        #puts "Error: variables are not in correct order!: factor1: " + factor1.factor_id.to_s + " factor2: " + factor2.factor_id.to_s
        if common_vars == 1
          # assume that second factor has variable where it should be
          factor1.set_factor_vals(swap(factor1.factor_vals, 0, factor1.factor_vars.find_index(factor2.factor_vars[0])))
          factor1.set_factor_vars(swap_vars(factor1.factor_vars, factor1.factor_vars.find_index(factor2.factor_vars[0])))
        elsif common_vars == 2
          factor1.set_factor_vals(swap(factor1.factor_vals, 0, factor1.factor_vars.find_index(factor2.factor_vars[0])))
          factor1.set_factor_vars(swap_vars(factor1.factor_vars, factor1.factor_vars.find_index(factor2.factor_vars[0])))
          factor1.set_factor_vals(swap(factor1.factor_vals, 0, factor1.factor_vars.find_index(factor2.factor_vars[1])))
          factor1.set_factor_vars(swap_vars(factor1.factor_vars, factor1.factor_vars.find_index(factor2.factor_vars[1])))
        else
          puts 'TOO MANY COMMON VAR'
          return nil
        end
      end

      new_factor_value = multiply(factor1.factor_vals, factor2.factor_vals, common_vars-1, get_depth(factor1.factor_vals) - 1)
      product_list = product_list[1..-1]
      product_list[0].set_factor_vals(new_factor_value)
      product_list[0].set_factor_vars(factor1.factor_vars + factor2.factor_vars[common_vars..-1])
    end

    pretty_print_factor(product_list[0])

  end

  puts '---------------------------'
  puts 'Sumout Hidden Variables from Factors'
  puts '---------------------------'

  # 3) Sum out hidden variables from factor product
  product_factor = product_list[0].factor_vals
  product_vars = product_list[0].factor_vars
  hidden_vars.each do |h|
    if product_vars.include?(h)
      index = product_vars.index(h)
      # Sum out
      product_factor = sumout(product_factor, 0, index)
      # Remove var from list of vars
      product_vars.delete(h)
      pretty_print_factor(Factor.new(product_factor, product_vars))
    end
  end

  puts '---------------------------'
  puts 'Normalization of Factor'
  puts '---------------------------'

  # 4) Normalize if need
   normalize(product_factor)

  # Pretty Print Final Normalized Factor
  pretty_print_factor(Factor.new(normalize(product_factor), product_vars))

end


# --------------------------
# Main
# --------------------------

# Test Factors
#test_1 = [[[1,2],[3,4]],[[5,6],[7,8]]]
#test_2 = [[[9,10],[11,12]],[[13,14],[15,16]]]
#test_3 = [[[17,18],[19,20]],[[21,22],[23,24]]]
#test_4 = [[[[1,2],[3,4]],[[5,6],[7,8]]],[[[9,10],[11,12]],[[13,14],[15,16]]]]
t1 = Factor.new([[1,2],[3,4]], [:Y, :X])
#t2 = Factor.new([[5,6], [7,8]], [:Y, :Z])
#t3 = Factor.new([[9,10],[11,12]], [:Z, :W])
#t4 = Factor.new(5, [])
t5 = Factor.new([[[1,2],[3,4]],[[5,6],[7,8]]], [:FH, :FS, :FM])
t6 = Factor.new([[[[1,2],[3,4]],[[5,6],[7,8]]],[[[9,10],[11,12]],[[13,14],[15,16]]]], [:FH, :FS, :FM, :NDG])

# CPTs (factors)
factor_fm = Factor.new([27.to_f/28, 1.to_f/28],[:FM])
factor_na = Factor.new([7.to_f/10, 3.to_f/10], [:NA])
factor_fs = Factor.new([0.95, 0.05], [:FS])
factor_fh = Factor.new([[[[1,0.6],[0.8,0.35]],[[0.5,0.1],[0.25,0.01]]],[[[0,0.4],[0.2,0.65]],[[0.5,0.9],[0.75,0.99]]]], [:FH, :FS, :NDG, :FM])
factor_ndg = Factor.new([[[1,0.5],[0.6,0.2]],[[0,0.5],[0.4,0.8]]], [:NDG, :FM, :NA])
factor_fb = Factor.new([[0.9,0.4],[0.1,0.6]],[:FB, :FS])


# Part 3 2)
#factor_list = [factor_fh, factor_fs, factor_ndg, factor_fm, factor_na]
#evidence = {}
#hidden_variables = [:NA, :FM, :FS, :NDG]
#query = [:FH]
=begin
Factor ID: 13
------------------------
~FH | 0.9269298214285714
FH | 0.07307017857142858
------------------------
=end

# Part 3 3)
#factor_list = [factor_fh, factor_ndg, factor_fm, factor_na, factor_fs]
#evidence = {:FH=>1, :FM=>1}
#hidden_variables = [:NA, :NDG]
#query = [:FS]
=begin
Factor ID: 11
------------------------
~FS | 0.9140585287923898
FS | 0.08594147120761021
------------------------
=end

# Part 3 4)
#factor_list = [factor_fh, factor_ndg, factor_fm, factor_na, factor_fb, factor_fs]
#evidence = {:FH=>1, :FM=>1, :FB=>1}
#hidden_variables = [:NA, :NDG]
#query = [:FS]
=begin
Factor ID: 11
------------------------
~FS | 0.6393326053279833
FS | 0.36066739467201664
------------------------
=end

# Part 3 5)
factor_list = [factor_fh, factor_ndg, factor_na, factor_fm, factor_fb, factor_fs]
evidence = {:FH=>1, :FM=>1, :FB=>1, :NA=>1}
hidden_variables = [:NDG]
query = [:FS]
=begin
Factor ID: 10
------------------------
~FS | 0.6615598885793871
FS | 0.33844011142061287
------------------------
=end

inference(factor_list, query, hidden_variables, evidence)
