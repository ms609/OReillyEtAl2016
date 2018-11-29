# Converts the .tre outputs produced by TNT runs to nexus files
# Edit this line to point to your oreilly folder
$dir = "C:/Research/oreilly";

## Nothing below this line should need editing.

use File::Find;
use File::stat;
use Time::localtime;
print "\r\ntnt2nex.pl: Converts the .tre outputs produced by TNT runs to nexus files\r\n";
@taxa = ("Osteolepiformes", "Ichthyostega", "Archeria", "Proterogyrinus", "Ariekanerpeton", "Seymouria", "Kotlassia", "Nectridea", "Utaherpeton", "Asaphestera", "Lysorophia", "Cardiocephalus", "Brachystelechidae", "Rhynchonkos", "Pantylus", "Microbrachis", "Adelogyrinidae", "Caeciliidae", "Typhlonectidae", "Ichthyophiidae", "Rhinatrematidae", "Eocaecilia", "Rhyacotritonidae", "Plethodontinae", "Bolitoglossinae", "Spelerpinae", "Hemidactylinae", "Amphiumidae", "Salamandridae", "Dicamptodontidae", "Ambystomatidae", "Proteidae", "Sirenidae", "Cryptobranchidae", "Hynobiidae", "Karaurus", "Leiopelmatidae", "Ascaphidae", "Pelodytidae", "Megophryidae", "Pelobatidae", "Scaphiopodidae", "Ranoidea", "Sooglossidae", "Heleophrynidae", "Myobatrachidae", "Calyptocephallidae", "Hyloidea", "Rhinophrynidae", "Pipidae", "Bombinatoridae", "Discoglossidae", "Triadobatrachus", "Aistopoda", "Westlothiana", "Procolophonidae", "Captorhinidae", "Synapsida", "Diadectes", "Limnoscelis", "Solenodonsaurus", "Gephyrostegidae", "Doleserpeton", "Amphibamus", "Apateon", "Tersomius", "Ecolsonia", "Eryops", "Dendrerpeton", "Colosteidae", "Baphetidae", "Crassigyrinus", "Tulerpeton", "Acanthostega", "Panderichthyidae");
print " Reading directory ". $dir . "/Trees";
find (\&tnt2nex, $dir . "/Trees/");
@lines = <NEXSRC>;
close NEXSRC;
print "\nDone.";

sub tnt2nex() {
	if (-f and /\.tre|\.tnttree$/) {
    $infile = $_;
    $outfile = $_;
    $outfile =~ s/\.\w+$/.nex/i;
    $outfile = "../nexTrees/" . $outfile;
    $i = 0;
    if (!(-e $outfile) || -C $infile < -C $outfile) {
      print "\n- Processing $infile: ";
      print "[+] " if (!(-e $outfile));
      open (FILE, "<$infile") or warn " ERROR: Can't find TNT trees list $dir/$infile.\n";
      @lines = <FILE>;
      close FILE;
          
      shift(@lines);
      pop(@lines);
      
      open (OUTPUT, ">$outfile")  or warn "!! Can't open $outfile: $!\n";
      print OUTPUT "#NEXUS\nbegin taxa;\n\tdimensions ntax=75;\n\ttaxlabels";
      for (@taxa) {
        print OUTPUT "\n\t\t" . $_;
      }
      print OUTPUT "\n\t;\nend;\nbegin trees;\n";
      for (@lines) {
        ++$i;
        # Replace taxon numbers with taxon names
        s/([\s\(,])(\d+)(?= )/$1$taxa[$2],/g;
        s/, ?\)/)/g;
        # Annotations
        s/(=\S*)\//$1;/g;
        s/=(\S+)/[&Annot="$1"]/g;
        s/;/; /g;
        # Place commas between clades
        s/\)\(/),(/g;
        s/\]\s*\(/], (/g;
        # Separate multiple trees
        s/[\*; ]+;?$/;/;
        # Name trees
        s/^(.*?)([\d\w_]+)/tree tree$i = [&U] $1$2/;
        print OUTPUT "\t" . $_;
      }
      print OUTPUT "\nend;";
      close (OUTPUT);
      print scalar @taxa . " taxa translated.";
    } else {
      print "\nSkipping existing files, at $infile" if (rand(1) < 0.001);
    }
  }
}