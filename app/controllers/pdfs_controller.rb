class PdfsController < ApplicationController
  
  def index
    #do nothing and render the default template
  end

  # POST /pdfs
  def create
    #look at content_type and original filename to determine if this is a PDF:
    if params[:pdfs][:pdf].content_type == 'application/pdf' and params[:pdfs][:pdf].original_filename.split('.')[-1] == 'pdf'

    output_filename = "clean_#{params[:pdfs][:pdf].original_filename.to_s}"
    
    %x{ gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=tmp/#{output_filename} -c .setpdfwrite -f #{params[:pdfs][:pdf].tempfile.path} }
    
    output_file = File.read("tmp/#{output_filename}")
    
    respond_to do |format|
      
        format.html do
          send_data output_file.to_s, :disposition => 'inline', :filename => output_file, :type => 'application/pdf', :x_sendfile => true
      end
    end
    else
     #this is not a pdf file. Let them know.
      flash.notice = t('not_a_pdf')
      redirect_to :action => 'index'
  end
 end
end
