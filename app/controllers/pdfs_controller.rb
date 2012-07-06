class PdfsController < ApplicationController

  def index
    #do nothing and render the default template
  end

  # POST /pdfs
  def create
    if params[:pdfs]
      if is_pdf? params[:pdfs][:pdf]
      output_filename = "clean_#{strip_chars(params[:pdfs][:pdf].original_filename)}"

      tempfile = Tempfile.new('pdf')
      %x{ gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=#{tempfile.path} -c .setpdfwrite -f #{params[:pdfs][:pdf].tempfile.path} }

      output_file = File.read(tempfile.path)
      respond_to do |format|
          format.html do
            send_data output_file.to_s, :disposition => 'inline', :filename => output_filename, :type => 'application/pdf', :x_sendfile => true
        end
      end
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
