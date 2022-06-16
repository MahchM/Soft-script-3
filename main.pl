use warnings;
use strict;

my $logs = 'access.log';
my $cnt = 0;
my @ips = ();
my %top_ips = ();

open(FH, '<', $logs) or die $!;

while(<FH>){
   $cnt+=1;
   #Находит код ошибки 4ХХ
  my $c1 = $_ =~ m "\"\s(4\d{2})\s";
  #Находит отсутствие Mozilla
  my $c2 = not $_  =~ m "Mozilla";
  #Пустой referer
  my $c3 = $_ =~ m "\d+\s(\"\-\")\s\"";
  #Запрос не GET или POST
   my $c4 = not $_ =~ m "(GET|POST)";
   #Не латинские символы и знаки пунктуации
   my $c5 = $_ =~ m "(\\x[a-zA-Z0-9]{2,3})";
  if (($c1+$c2+$c3+$c4+$c5)>1){
     print("$cnt $_");
  }
  $_ =~ m"^(\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3})";
  push(@ips,$1);
}

foreach (@ips){
   if (defined $top_ips{$_}){
   $top_ips{$_} = $top_ips{$_} + 1;   
   }else{
      $top_ips{$_} = 1;
   }   
}
print "\nTop 10 IPs:\n";
$cnt = 0;
foreach my $ip (sort { $top_ips{$b} <=> $top_ips{$a} } keys %top_ips) {
    print "$cnt: $ip, $top_ips{$ip}\n";
    $cnt= $cnt +1;
    if ($cnt>10){ last;}
}