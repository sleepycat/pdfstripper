class PdfStreamer
  attr_accessor :after_close_proc

  def initialize(outfile)
    @outfile = outfile
  end

  def each
    yield(@outfile.read(65536)) while !@outfile.eof?
  end

  def close
    @outfile.close if @outfile.respond_to?(:close)
    @after_close_proc.call if @after_close_proc
  end
end


