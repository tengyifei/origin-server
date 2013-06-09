module Console::ConsoleHelper

  def openshift_url(relative='')
    "https://openshift.redhat.com/app/#{relative}"
  end

  def legal_opensource_disclaimer_url
    openshift_url 'legal/opensource_disclaimer'
  end

  #FIXME: Replace with real isolation of login state
  def logout_path
    signout_path
  end

  def outage_notification
  end

  def product_branding
    content_tag(:span, "<strong>Getup</strong> OpenShift Origin".html_safe, :class => 'brand-text headline')
  end

  def product_title
    'Getup OpenShift Origin'
  end
end
