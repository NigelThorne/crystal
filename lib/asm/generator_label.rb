require "asm/label_object"

class Asm::GeneratorLabel < Asm::LabelObject
  def initialize(asm)
    @asm = asm
  end
  def at pos
    @position = pos
  end
  def length 
    0
  end
  def set!
    @asm.add_value self
    self
  end
end