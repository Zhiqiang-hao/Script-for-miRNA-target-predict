#!/usr/bin/perl
open$input_file,"/home/li/others/fanchunyan/input"or die;
while($line=<$input_file>){
@lines=split"\t",$line;
$miRNA_inf=$lines[2];
$gene_inf=$lines[0];
@gene_infs=split" ",$gene_inf;
@miRNA_infs=split" ",$miRNA_inf;
$miRNA_seq=reverse $miRNA_infs[1];
@atcg=split"",$miRNA_seq;

for($n=0;$n<scalar@atcg;$n++){
$m++ if $atcg[$n]=~/[AUCG]/;
push@start_end9_12,$n if $atcg[$n]=~/[AUCG]/ and ($m==9 or $m==12);
push@start_end2_8,$n if $atcg[$n]=~/[AUCG]/ and ($m==2 or $m==8);
}
$m=0;
$align=reverse $lines[1];
@aligns=split"",$align;
for($n=$start_end9_12[0];$n<=$start_end9_12[1];$n++){
$indel9_12++ if $aligns[$n] eq ' ';
}

for($n=$start_end2_8[0];$n<=$start_end2_8[1];$n++){
$match2_8++ if $aligns[$n] eq '|';
}
$indel_all=$align=~tr/ / /;

$condition1=1  if $indel9_12>1 and $indel9_12<6;
$condition2=1  if $match2_8 ==7 and $start_end2_8[0]==1 and $start_end2_8[1]==7;
$condition3=1  if $indel_all-$indel9_12<=4;

if($condition1 and $condition2 and $condition3){
$miRNA_nam=$miRNA_infs[4];
($gene_nam,$position)=split":",$gene_infs[4];
$mfeperfect=$lines[3];$mfesite=$lines[4];$mferatio=$lines[5];
$lincRNA='lincRNA: 5\''.$gene_infs[1].' 3\'';
$miRNA=' miRNA: 3\' '.$miRNA_infs[1].' 5\'';
$result.=$miRNA_nam."\t".$gene_nam."\t".$position."\t".$mfeperfect."\t".$mfesite."\t".$mferatio."\n".$lincRNA."\n".(' 'x 11).$lines[1]."\n".$miRNA."\n";
}

$indel9_12=$indel_all=$match2_8=$condition1=$condition2=$condition3=0;@start_end9_12=@start_end2_8=();
}
$result="zma-miRNA	Transcript	start-end	MFEperfect	MFEsite	MFEratio\n".$result;
open$out,'>',"/home/li/others/fanchunyan/1_decoy"or die;
print$out($result);
