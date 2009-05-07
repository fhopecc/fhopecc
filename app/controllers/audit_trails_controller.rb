require 'oci8'
class AuditTrailsController < ApplicationController
  layout "hltb"

  def show
    pars = params[:audit_trail]
		sd = Date.civil(pars["start_date(1i)"].to_f, pars["start_date(2i)"].to_f,
                            pars["start_date(3i)"].to_f)
		ed = Date.civil(pars["end_date(1i)"].to_f, pars["end_date(2i)"].to_f,
                            pars["end_date(3i)"].to_f)
		
		pars[:sd] = sd
		pars[:ed] = ed

		@username = pars[:username]
		@duration = sd.to_s + " ~ " + ed.to_s
    
		unless @username == 'ALL'
			@als = AuditTrail.find :all, :conditions => [
		       "owner = 'ELTWEB' and
            username = :username and 
					  timestamp between :sd and :ed", pars]
		else
			@als = AuditTrail.find :all, :conditions => [
		       "owner = 'ELTWEB' and
					  timestamp between :sd and :ed", pars]
		end

		@padding_line = 19 - @als.size
		@padding_line_audit = 29 - @als.size
		@apptime = sd.to_s
		@terminal ||= @als[0].terminal if @als[0]
		@ip = IPSocket.getaddress(@terminal) if @terminal

		if @username == 'ALL'
			render :action => 'all_report'
		end

  end

end
