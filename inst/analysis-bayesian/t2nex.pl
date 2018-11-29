## Called by bayesgen.pl
## Set directory below.

##################################
use File::Find;
use File::stat;
use Time::localtime;
print "\r\n\rt2nex.pl: Converts the .tre outputs produced by Mrbayes runs to nexus files\r\n\r\n\r\n\r\n";
#$dir = "C:/Research/iw/Trees";
$dir = "C:/Bayes64/iwor";
$burninfrac = 0.1;
$ngen = 400000;
$samplefreq = 500;
@taxa = ("Osteolepiformes", "Ichthyostega", "Archeria", "Proterogyrinus", "Ariekanerpeton", "Seymouria", "Kotlassia", "Nectridea", "Utaherpeton", "Asaphestera", "Lysorophia", "Cardiocephalus", "Brachystelechidae", "Rhynchonkos", "Pantylus", "Microbrachis", "Adelogyrinidae", "Caeciliidae", "Typhlonectidae", "Ichthyophiidae", "Rhinatrematidae", "Eocaecilia", "Rhyacotritonidae", "Plethodontinae", "Bolitoglossinae", "Spelerpinae", "Hemidactylinae", "Amphiumidae", "Salamandridae", "Dicamptodontidae", "Ambystomatidae", "Proteidae", "Sirenidae", "Cryptobranchidae", "Hynobiidae", "Karaurus", "Leiopelmatidae", "Ascaphidae", "Pelodytidae", "Megophryidae", "Pelobatidae", "Scaphiopodidae", "Ranoidea", "Sooglossidae", "Heleophrynidae", "Myobatrachidae", "Calyptocephallidae", "Hyloidea", "Rhinophrynidae", "Pipidae", "Bombinatoridae", "Discoglossidae", "Triadobatrachus", "Aistopoda", "Westlothiana", "Procolophonidae", "Captorhinidae", "Synapsida", "Diadectes", "Limnoscelis", "Solenodonsaurus", "Gephyrostegidae", "Doleserpeton", "Amphibamus", "Apateon", "Tersomius", "Ecolsonia", "Eryops", "Dendrerpeton", "Colosteidae", "Baphetidae", "Crassigyrinus", "Tulerpeton", "Acanthostega", "Panderichthyidae");
print " Reading directory ". $dir;
find (\&t2nex, $dir . "/");
@lines = <NEXSRC>;
close NEXSRC;
print "\nConverted files. Now to calculate consensus trees:";
# Before executing the below script, do check that there are no 'dud' files...
exec "Rscript bayesCons.R"; # Calculate consensus trees at 20 probability values, 0.5..1.0
print "\r\nDone.";

sub t2nex() {
	if (-f and /\.run\d+\.t$/) {
    $infile = $_;
    $outfile = $_;
    $outfile =~ s/\.t$/.nex/i;
    $outfile = "nexTrees/" . $outfile;
    $i = 0;
    if (!(-e $outfile) || -C $infile < -C $outfile) {
      print "\n- Processing $infile: ";
      print "[+] " if (!(-e $outfile));
      open (FILE, "<$infile") or warn " ERROR: Can't find MrBayes trees list $dir/$infile.\n";
      @lines = <FILE>;
      close FILE;
      open (OUTPUT, ">$outfile")  or warn "!! Can't open $outfile: $!\n";
      for (@lines) {
        ++$i;
        if ($i < 5) {
          print OUTPUT; 
        } elsif ($i > 161) { # The number 2538 was here on 2018-04-26... not sure where it came from!
          s/:[^,\(\)]+//g;
          # Replace taxon numbers with taxon names
          s/([,\(\)])(\d+)/$1$taxa[$2 - 1]/g;
          ## Annotations
          #s/(=\S*)\//$1;/g;
          #s/=(\S+)/[&Annot="$1"]/g;
          #s/;/; /g;
          #
          ## Place commas between clades
          #s/\)\(/),(/g;
          #s/\]\s*\(/], (/g;
          ## Separate multiple trees
          #s/[\*; ]+;?$/;/;
          # Name trees
          # s/^(.*?)([\d\w_]+)/tree tree$i = [&U] $1$2/;
          print OUTPUT "\t" . $_;
        }
      }
      print OUTPUT "\nend;";
      close (OUTPUT);
    } else {
      print "\nSkipping existing files, at $infile" if (rand(1) < 0.001);
    }
  }
}