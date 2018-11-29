# Runs mpts.run for files 001 > 100
# Edit this line to point to your /Trees folder
$dir = "C:/Research/oreilly";

# TNT does not find optimal trees with k=2 on: 100_20_6, 100_20_8, 100_44_3
## Nothing below this line should need editing.
print "\r\nmptgen.pl: generate most parsimonious trees using TNT";

open (TEMPLATE, "<$dir/tnt_template.run") or warn "ERROR: can't find template file";
@template = <TEMPLATE>;
close TEMPLATE;


foreach my $rep (1..10) {
  foreach my $nchar (100, 350, 1000) {
    foreach my $rate (1..100) {
      $rate_rep = $rate . "_" . $rep;
      $fileno = $nchar . "/" . $rate_rep;
      if (-e "$dir/Trees/k200.$fileno.sym") {
        print "\nSkipping $fileno: results already exist for k200";
      } else {
        print "\n" . localtime . ": Processing $fileno...";
        $scriptfile = "$dir/temp_tnt_script.$nchar.$rate.$rep.run";
        open (SCRIPT, ">", $scriptfile) or warn "Can't open script file";
        for (@template) {
          $line = $_;
          $line =~ s/%1/$nchar/g;
          $line =~ s/%2/$rate_rep/g;
          print SCRIPT $line;
        }
        close SCRIPT;
        system("tnt \"proc $scriptfile\";"); # tnt_cmd is a copy of the COMMAND LINE version of tnt
        unlink($scriptfile);
        # To run TNT using the system command it is necessary (in Windows) to add its 
        # containing folder to the System Path, under 'Environment Variables',
        # or to include a copy of the executable in the same folder as mptgen.pl
        
        # I recommend using the command-line version of the program with this script.
      }
    }
  }
}
#do "tnt2nex.pl";
