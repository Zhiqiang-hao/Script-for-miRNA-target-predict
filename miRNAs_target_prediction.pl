#!/usr/bin/perl
open$input_file,"/home/li/Myopsalax/LncRNA/v3/miRna/out_tot"or die;
while($line=<$input_file>){
if($line=~/^5/){$gene_inf=$line;
@gene_infs=split" ",$gene_inf;
$new=1;
}
if($new){
$align0=$1 if $line=~/^   (.*)\n/;
}
if ($line=~/^3/){$new=0;
$miRNA_inf=$line;
@miRNA_infs=split" ",$miRNA_inf;
$miRNA_seq=reverse $miRNA_infs[1];
@atcg=split"",$miRNA_seq;}
if($line=~/MFE of perfect match: (\S+)/){
$mfeperfect=$1;}
if($line=~/MFE of this site: (\S+)/){
$mfesite=$1;}
if($line=~/MFEratio: (\S+)/){
$mferatio=$1;
for($n=0;$n<scalar@atcg;$n++){
$m++ if $atcg[$n]=~/[AUCG]/;
push@start_end9_12,$n if $atcg[$n]=~/[AUCG]/ and ($m==9 or $m==12);
}
$m=0;
$align=reverse $align0;
@aligns=split"",$align;
for($n=$start_end9_12[0];$n<=$start_end9_12[1];$n++){
$indel9_12++ if $aligns[$n] eq ' ';
}

for($n=0;($n+1)<length$align;$n++){$bi=$aligns[$n].$aligns[$n+1];
$mismatch++ if $bi=~/  /;
}
$indel_all=$align=~tr/ / /;

$condition1=1  if $indel9_12<=1;
$condition2=1  unless $mismatch;
$condition3=1  if $indel_all-$indel9_12<=4;

if($condition1 and $condition2 and $condition3){
$miRNA_nam=$miRNA_infs[4];
($gene_nam,$position)=split":",$gene_infs[4];
$lincRNA=' lncRNA: 5\''.$gene_infs[1].' 3\'';
  $miRNA='  miRNA: 3\''.$miRNA_infs[1].' 5\'';
$result.=$miRNA_nam."\t".$gene_nam."\t".$position."\t".$mfeperfect."\t".$mfesite."\t".$mferatio."\n".$lincRNA."\n".(' 'x 11).$align0."\n".$miRNA."\n";
}

$indel9_12=$indel_all=$mismatch=$condition1=$condition2=$condition3=0;
}}
$result="miRNA	Transcript	start-end	MFEperfect	MFEsite	MFEratio\n".$result;
open$out,'>',"/home/li/Myopsalax/LncRNA/v3/miRna/miRNA_targets"or die;
print$out($result);
