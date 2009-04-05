DocNo = '0982400051'
require 'hltb'
Tmp = "tmp/hltb"
Jpg = File.join(Tmp, 'jpg') 
directory Tmp
directory Jpg
namespace "tax_report" do
	task :download => Tmp do
    Hltb.download_tax_report DocNo
	end

	task :print => [Jpg, :download] do
    Hltb.print_tax_report DocNo
	end
end
