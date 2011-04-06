require 'spec_helper'


describe "PdfsController" do

  describe "GET /pdfs_controller" do
    it "should show the index page" do
      get root_path
      response.status.should be(200)
    end
  end

  describe "POST /pdfs_controller" do
 
   it "should redisplay index if no file is posted" do
      post create_path
      response.body.should include("No file was selected.")
    end

    it "should reject non PDF files" do
      visit root_path
      attach_file "pdfs_pdf", Rails.root.join("spec", "fixtures", "not_a_pdf.odt" ).to_s
      click_button 'Send!'
      page.should have_content("This file is not recognizable as a PDF.")
    end

    it "should respond to a PDF with a PDF" do
      visit create_path
      attach_file "pdfs_pdf", Rails.root.join("spec", "fixtures", "restricted.pdf" ).to_s
      click_button 'Send!'
      page.response_headers["Content-Type"].should == "application/pdf"
    end

    it "should strip replace non-word characters with underscores " do
      controller = PdfsController.new
      controller.send(:strip_chars, "Inspector's safety guide (2).pdf").should == "Inspectors_safety_guide_2.pdf"
      controller.send(:strip_chars, "*(&%^@test.pdf").should == "test.pdf"
      
    end
 end
end
