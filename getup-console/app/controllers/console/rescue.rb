module Console
  module Rescue
    extend ActiveSupport::Concern

    included do
      rescue_from ActiveResource::ConnectionError, :with => :generic_error
      rescue_from ActiveResource::ResourceNotFound, :with => :page_not_found
      rescue_from RestApi::ResourceNotFound, :with => :resource_not_found
      rescue_from Console::AccessDenied, :with => :console_access_denied
    end

    protected
      def resource_not_found(e)
        if respond_to? :domain_is_missing
          domain_is_missing if e.respond_to?(:domain_missing?) && e.domain_missing?
        end

        alternatives = begin
            if Application == e.model
              @domain.applications.map do |app|
                [ I18n.t(:app_alternative, app: app.name), application_path(app)]
              end.tap do |links|
                links << [I18n.t(:Create_a_New_Application), new_application_path] if links.empty?
              end if @domain rescue nil
            elsif ApplicationType == e.model
              [[I18n.t(:see_other_app_types), application_types_path]]
            end
          end if e.respond_to? :model

        page_not_found(e, e.message, alternatives)
      end

      def page_not_found(e=nil, message=nil, alternatives=nil)
        @reference_id = request.uuid
        logger.warn "Page not found - Reference ##{@reference_id}"
        @message, @alternatives = message, alternatives
        render 'console/not_found'
      end

      def generic_error(e=nil, message=nil, alternatives=nil)
        @reference_id = request.uuid
        logger.error "Unhandled exception reference ##{@reference_id}: #{e.message}\n#{e.backtrace.join("\n  ")}"
        @message, @alternatives = message, alternatives
        render 'console/error'
      end

      def console_access_denied(e)
        logger.debug "Access denied: #{e}"
        redirect_to unauthorized_path
      end
  end
end
