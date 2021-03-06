require 'elf/object_file'
require 'elf/symbol_table_section'
require 'elf/text_section'
require 'elf/string_table_section'

module Elf

  class ObjectWriter
    def initialize(program , target)
      @object = Elf::ObjectFile.new(target)
      @object_space = program
      sym_strtab = Elf::StringTableSection.new(".strtab")
      @object.add_section sym_strtab
      @symbol_table = Elf::SymbolTableSection.new(".symtab", sym_strtab)
      @object.add_section @symbol_table

      @text = Elf::TextSection.new(".text")
      @object.add_section @text
      
      program.link_at( 0 , program.context )
    
      binary = program.assemble(StringIO.new )
      
      blocks = []
      program.classes.values.each do |clazz| 
        clazz.functions.each do |f|
          f.blocks.each do |b|
              add_symbol "#{clazz.name}::#{f.name}@#{b.name}" , b.position
            end
        end
      end
      blocks += [program.entry , program.exit , program.main]
      blocks.flatten.each do |b|
        add_symbol b.name.to_s , b.position
      end
      set_text binary.string      
    end
    attr_reader :text
    def set_text(text)
      @text.text = text
      add_symbol "_start", 0
    end
    def add_symbol(name, offset, linkage = Elf::Constants::STB_GLOBAL)
      @symbol_table.add_func_symbol name, offset, @text, linkage
    end

    def save(filename)
      to = File.open(filename, 'wb') 
      @object.write to
      to.close
    end

  end
end