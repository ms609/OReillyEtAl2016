# Runs mpts.run for files 001 > 100
# Edit this line to point to your /Trees folder
$dir = "C:/Research/oreilly";

# TNT does not find optimal trees with k=2 on: 100_20_6, 100_20_8, 100_44_3
## Nothing below this line should need editing.
print "\r\nmptgen.pl: generate most parsimonious trees using TNT";

open (TEMPLATE, "<$dir/tntscript/template.run") or warn "ERROR: can't find template file";
@template = <TEMPLATE>;
close TEMPLATE;


foreach my $rep (1..10) {
  foreach my $nchar (100, 350, 1000) {
    foreach my $rate (1..100) {
      $fileno = $nchar . "_" . $rate . "_" . $rep;
      if (-e "$dir/Trees/k200.$fileno.so20.con.tre") {
        print "\nSkipping $fileno: results already exist for k200, so20";
      } else {
        print "\n" . localtime . ": Processing $fileno...";
        $scriptfile = "$dir/tntscript/run$fileno.run";
        open (SCRIPT, ">", $scriptfile) or warn "Can't open script file";
        for (@template) {
          $line = $_;
          $line =~ s/%1/$fileno/g;
          print SCRIPT $line;
        }
        close SCRIPT;
        system("tnt_cmd \"proc $scriptfile\";"); # tnt_cmd is a copy of the COMMAND LINE version of tnt
        # To run TNT using the system command it is necessary (in Windows) to add its containing 
        # folder to the System Path, under 'Environment Variables'
      }
    }
  }
}
#do "tnt2nex.pl";