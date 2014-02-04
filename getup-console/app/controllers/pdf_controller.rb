class PdfController < ConsoleController
  include Console::UserManagerHelper

  def show
    id = params[:id]
    result = user_manager_billing_invoice_pdf(id)
    render content_type: "application/pdf", text: "#{result.body}"
  end
end
