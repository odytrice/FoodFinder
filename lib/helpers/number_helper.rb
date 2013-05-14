# To change this template, choose Tools | Templates
# and open the template in the editor.

module NumberHelper
  def number_to_currency(number,options={})
    #initialze defaults
    unit        = options[:unit]      || '$'
    precision   = options[:precision] || 2
    delimiter   = options[:delimiter] || ','
    separator   = options[:separator] || '.'
    
    separator = '' if precision == 0
    integer, decimal = number.to_s.split('.')
    
    #insert "," delimiters
    i= integer.length
    until ( i <= 3)
      i -= 3
      integer = integer.insert(i, delimiter)
    end

    if precision == 0
      precise_decimal = ''
    else
      #make sure decimal is not nil
      decimal ||= "0"
      #make sure the decimal is not too large
      decimal = decimal[0, precision - 1]
      #make sure the decimal is not too short
      precise_decimal = decimal.ljust(precision, "0")
    end
    
    return unit + integer + separator + precise_decimal
  end
end
