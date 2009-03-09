class DbChecklistsController < ApplicationController
	include DbaHelper
	#helper DbaHelper
	layout 'dba'

	DAY_CHECKLIST = 
	[ '檢視Listener.log 有無異常連線', 
		'檢視 Logon Trace Table 資料，有無異常連線與作業', 
		'檢查alert_<SID>.log有無錯誤訊息',
		'檢視 DB 主機磁碟機空間使用情況',
		'檢視 DB TABLESPACE 使用率是否有超過 90% 的使用空間',
		'檢查是否有無效的物件(Table,Index)',
		'檢查 SGA 使用情形',
		'資料庫是否處於 Archive Log File 的備份模式',
		'檢查Index,Table存放於正確的 TBS 內',
		'檢查資料庫用戶授權情況',
		'檢查資料庫每日備份記錄']
  WEEK_CHECKLIST = [
		'檢視離職人員使用者帳號及權限是否註銷', 
		'檢查資料庫用戶ROLE權限', 
		'檢查table授權情況' 
	]
	MONTH_CHECKLIST = [
		"檢視#{Date.today.month - 3}月的 batchlog 是否備出"
	]
  SEASON_CHECKLIST = [
		'Performance Report收集(Statspack)',
		'檢視系統帳號之密碼是否更新'
	]
	RANDOM_CHECKLIST = [
    '資料庫效能調整及調校服務'
	]

	def index
		redirect_to db_checklist_path(12)
	end

	def show
		if params[:id].length <= 2 then
			@year  = Date.today.year
			@month = Date.today.month
			@day   = params[:id]
		elsif params[:id].length == 4 then
			@year = Date.today.year
			@month = params[:id][0..1]
			@day   = params[:id][2..3]
		else
			@year  = params[:id][0..3]
			@month = params[:id][4..5]
			@day   = params[:id][6..7]
		end
		@today = Date.civil @year.to_i, @month.to_i, @day.to_i
    @monday = @today - @today.wday 
		@friday = friday_date @today
		@month_start = Date.civil(@today.year, @today.month, 1)
		@season_start = Date.civil(@today.year, season_start_month(@friday.month), 1)

	end

	def checklist
		@today = Date.today
    @monday = @today - @today.wday 
		@friday = friday_date @today
		@month_start = Date.civil(@today.year, @today.month, 1)
		@season_start = Date.civil(@today.year, season_start_month(@friday.month), 1)
	end
end
