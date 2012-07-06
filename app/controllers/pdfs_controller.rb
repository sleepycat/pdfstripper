class PdfsController < ApplicationController

  def index
    #do nothing and render the default template
  end

  # POST /pdfs
  def create
    if params[:pdfs]
      if is_pdf? params[:pdfs][:pdf]

        tempfile = Tempfile.new('pdf')
        %x{ #{GHOSTSCRIPT_BIN} -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=#{tempfile.path} -c .setpdfwrite -f #{params[:pdfs][:pdf].tempfile.path} }

        output_filename = "clean_#{strip_chars(params[:pdfs][:pdf].original_filename)}"

        response.headers['Content-Length'] = tempfile.size.to_s
        response.headers['Content-Type'] = "application/pdf"
        response.headers['Content-Disposition'] = "inline; filename=#{output_filename}"
        self.response_body = PdfStreamer.new tempfile

      else
       #this is not a pdf file. Let them know.
        flash.notice = t('not_a_pdf')
        redirect_to :action => 'index'
    end
  else
    #the form was sent without a file
    flash.notice = t('no_file')
    render :action => 'index'
  end
 end

  private

  def strip_chars filename
    #remove problematic charaters from the filename
    filename.chomp(".pdf").gsub(' ', '_').gsub(/\W/,'') + ".pdf"
  end

  def is_pdf? file
     file.content_type == 'application/pdf' && file.original_filename.split('.')[-1] == 'pdf' ? true : false
  end
end
