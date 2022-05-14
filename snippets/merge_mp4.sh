#! /bin/bash
set -x
cmd="concat:"
i=1
for file in $@;do
	cmd="${cmd}$i.ts|"
	ffmpeg -i $file -vcodec copy -acodec copy -vbsf hevc_mp4toannexb $i.ts
	i=`expr $i + 1`
done

cmd=${cmd%%|}      # 如果变量尾部匹配 pattern，则删除最大匹配部分返回剩下的
ffmpeg -i "$cmd" -c copy -bsf:a aac_adtstoasc -movflags +faststart -y output.mp4
end_index=`expr $i - 1`

i=1
while [ $i -le $end_index ]; do
	rm $i.ts
	i=$(expr $i + 1)
done
