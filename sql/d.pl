my $h=0;
my $m=0;
my $pre=1;
while($h<24){
    for my $n (1,1,13) {
        my $nm=$m+$n;
        my $nh=$h;
        if($m==0 || $m==30) {
            $pre = 1;
        } else {
            $pre = 0;
        }
        print("insert into t\$segments(priority, content_id, start_time, end_time, preempt) values (5, 1, \"$h:$m:00\", \"$nh:".($nm-1).":59\", $pre);\n");
        if ($nm>=60) { 
            $nm=0;
            $nh=$h+1; 
        }
        $h=$nh;
        $m=$nm;
    }
}
