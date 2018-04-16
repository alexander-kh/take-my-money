class DailyRevenueReportsController < ApplicationController
  
  def show
    respond_to do |format|
      format.html {}
      format.csv do
        headers["X-Accel-Buffering"] = "no"
        headers["Cache-Control"] = "no-cache"
        headers["Content-Type"] = "text/csv; charset=utf-8"
        headers["Content-Disposition"] =
          %(attachment; filename="#{csv_filename}")
        headers["Last-Modified"] = Time.zone.now.ctime.to_s
        self.response_body = DayRevenueReport.to_csv_enumerator
      end
    end
  end
  
  private def csv_filename
    "daily_revenue_report-#{Time.zone.now.to_date.to_s(:default)}.csv"
  end
end