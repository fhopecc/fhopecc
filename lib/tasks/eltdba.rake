require 'lib/eltdb.rb'
require 'lib/elt.rb'
require 'benchmark'
DB   = ELTDB.new :ELTUD
TEST = ELTDB.new :ELTUDT
task :grant_mrole do |t|
	#DB.grant_mrole    'cwl07971', 'lnd'
	#DB.grant_mrole     'wiy06831', 'hou'
	#DB.grant_mrole     '06831', 'hou'
	#DB.grant_mrole    'ysj06660', 'wii'
	#TEST.grant_vrole  'ysj06660', 'vab'
	DB.grant_mrole    'wch03211', 'wxx'
end

task :reset_password do |t|
	#TEST.reset_password 'cwl07971', '54321'
	#TEST.reset_password 'ysj06660', 'a54321'
	#TEST.reset_password  'hjc03836', '54321a'
	#DB.reset_password  'hjc03836', '54321a'
end

task :revoke_mrole do 
	DB.revoke_mrole   'cwl07971', 'lnd'
end

task :grant_table_to_role do |t|
	ELTDB.grant_table_to_role 'WIIW920'
end

task :upload do
	test = ELT.new :ELTUAT
  test.upload "AVM611L_.class"
end

task :backup_table do
	['LNDT804'].each do |t|
		ELTDB.backup_table t
	end
end

task :create_pk do
	ELTDB.create_pk 'waah510',"HSN_CD", "DATA_YR","DATA_MO",
     "CLAT_G_LDGR_NO", "CLAT_S_LDGR_NO", "ADJ_PRD_MK", 
     "ITEM_CARY_FW_YR", "DATA_BL_YR"
end

task :getfiles do |t|
	test = ELT.new :ELTAPT
	root = '/elt/eltapp/bin/vab'
	bfs = ['eltftp.exe', 'eltftpput.exe', 'ProcessService.class']
  fs  = bfs.map do |f|
		File.join(root, f)
	end
  test.mget(4096, *fs)
end

task :update_vabserver do |t|
	system 'net use T: /delete'
	system 'net use T: \\\\vabserver\\VAB_FTX_SERVER'

	bfs = ['eltftp.exe', 'eltftpput.exe', 'ProcessService.class']
  bfs.each do |f|
    FileUtils.copy bfs, 'T:/'
	end
end

task :revoke_all_mroles do
  ELTDB.revoke_all_mroles
end

task :yhq_statics do

	sql = <<-EOS
        select count(*) as count
        from eltweb.yhqt002
        where data_send_date like '09802%'
        or data_send_date like '09801%'
	EOS
  egxs = EgxApplyLog.find_by_sql sql
	puts egxs.first.count 
end

task :ypm_counts do
	patch = Patch.find :all, :conditions => 
	     ["app_date like ? or app_date like ?", "09801%", "09802%"]
	puts patch.sum {|p| p.programs.count}
end

task :change_index_tablespace do
  DB.change_index_tablespace "PK_WXXW530", "ELTWXXIDX"
  DB.change_index_tablespace "I_WXXW602_03", "ELTWXXIDX"
end	
