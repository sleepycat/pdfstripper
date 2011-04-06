class PdfsController < ApplicationController
  
  def index
    #do nothing and render the default template
  end

  # POST /pdfs
  def create
    if params[:pdfs]
      #look at content_type and original filename to determine if this is a PDF:
      if params[:pdfs][:pdf].content_type == 'application/pdf' and params[:pdfs][:pdf].original_filename.split('.')[-1] == 'pdf'
      
      output_filename = "clean_#{strip_chars(params[:pdfs][:pdf].original_filename)}"

      %x{ gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=tmp/#{output_filename} -c .setpdfwrite -f #{params[:pdfs][:pdf].tempfile.path} }

      output_file = File.read("tmp/#{output_filename}")
      
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

end
