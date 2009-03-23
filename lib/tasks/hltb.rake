require 'hltb'
Tmp  = "tmp/hltb"
directory Tmp
namespace "tax_report" do
	task :download => Tmp do
    Hltb.download_tax_report '0982400051'
	end
end
