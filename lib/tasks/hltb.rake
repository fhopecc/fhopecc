DocNo = '09824000960' 
require 'hltb'
Tmp = "tmp/hltb"
Jpg = File.join(Tmp, 'jpg') 
directory Tmp
directory Jpg
namespace "tax_report" do
	task :download => Tmp do
    Hltb.download_tax_report DocNo[0..9]
	end
  
	desc "download and load tax report"
	task :print => [Jpg, :download] do
    Hltb.print_tax_report DocNo[0..9]
	end
end
