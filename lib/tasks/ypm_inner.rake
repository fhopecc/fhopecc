TMP = 'tmp/ypm'
LOG = 'log/sql'
SQL = 'lib/sql'
WXX = 'tmp/wxx'
directory TMP
directory LOG
directory SQL
directory WXX

desc "load and install sql"
task :load_sql => [LOG, TMP, SQL] do
	ELT.install_eltsql 'eltudt', 3, 244
	ELT.install_eltsql 'eltud', 3, 244
end

task :show_ypms do 
  p = EltPatch.find :first
	puts p.app_no
end

desc "wxx 815"
task :export_wxx815 => WXX do
	sql = <<SQL
select distinct a.exec_vouch_case_no,
hsn_cd||dst_cd||town_cd||tax_cd||subtax_cd||bl_yr_pd||data_no||manage_ck1_no||manage_ck2_no as manage_cd,
a.idn_ban,a.nm_co,
nvl(a.extend_e_date,a.coll_e_date) as limit_date, 
(a.unpaid_ba_tax+a.unpaid_misc1_amt+a.unpaid_misc2_amt+a.unpaid_misc3_amt+a.unpaid_misc4_amt+a.unpaid_misc5_amt+a.unpaid_misc6_amt) as unpaid,
b.brh_no, 
b.cur_amt
from wxxw360 a,wxxw815 b 
where a.idn_ban=b.post_idn 
and a.ctrl_case_tp='3'
order by b.cur_amt desc
SQL
	File.open "#{WXX}/wxx815.csv", "w" do |f|
    rs = EltPatch.find_by_sql sql
		f << "執行憑證案號, 管理代號, 統一編號, 名稱, 繳納期限, 欠稅額, 分行號, 存款額" << "\n"
		rs.each do |r|
      f << "#{r.exec_vouch_case_no}, #{r.manage_cd}, " <<
           "#{r.idn_ban}, #{r.nm_co}, #{r.limit_date}, " <<
					 "#{r.unpaid}, #{r.brh_no}, #{r.cur_amt}" << "\n"
		end
	end
end
