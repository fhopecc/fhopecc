require 'hltb'
Tmp = "tmp/hltb"
Jpg = File.join(Tmp, 'jpg') 
directory Tmp
directory Jpg
namespace "tax_report" do
	desc "download and load tax report"
	task :print, [:docn] => [Tmp, Jpg] do |t, args|
    Hltb.download_tax_report args.docn[0..9]
    Hltb.print_tax_report args.docn[0..9]
	end
end
