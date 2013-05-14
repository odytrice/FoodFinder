# To change this template, choose Tools | Templates
# and open the template in the editor.

class String
  def titleize
    self.split(' ').map{|word| word.capitalize }.join(" ")
  end
end
