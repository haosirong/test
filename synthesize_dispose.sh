#!/bin/bash
func="/usr/local/bin/functions.sh"
. $func
product_name=msm8974
echo "选择平台"
select plat_name in `ls /home/compiler/workspace/gphone`;do
  echo "you select $plat_name"
  break
done

echo "选择项目"
select proj_name in `ls /home/compiler/workspace/gphone/${plat_name}`;do
  echo "you select $proj_name"
  break
done

echo "选择副本"
select work_copy in `ls /home/compiler/workspace/gphone/${plat_name}/${proj_name}`;do
  echo "you select $work_copy"
  break
done

work_copy_path="/home/compiler/workspace/gphone/${plat_name}/${proj_name}/${work_copy}"
sw_version=`cat $work_copy_path/out/target/product/$product_name/system/build.prop | grep ro.build.version.bbk | awk -F '=' '{print $2}'`

sw_pkgs=`ls /home/compiler/workspace/gphone/release/${proj_name}/images/ | grep "$sw_version" | grep "tar.gz"`
if [ `echo "$sw_pkgs" | wc -w` -gt 1 ];then
  echo "输入要拷贝的软件包"
  select sw_pkg in $sw_pkgs;do
    echo "you select $sw_pkg"
    break
  done
  cp -v /home/compiler/workspace/gphone/release/${proj_name}/images/$sw_pkg ~/FFHSR/tmp
  cp -v /home/compiler/workspace/gphone/release/${proj_name}/images/${sw_pkg%.tar.gz}/apps.zip ~/FFHSR/tmp
  cp -v /home/compiler/workspace/gphone/release/${proj_name}/images/${sw_pkg%.tar.gz}/${sw_version}_md5.txt ~/FFHSR/tmp
  cp -v /home/compiler/workspace/gphone/release/${proj_name}/upgrade/${sw_version##*_}/${sw_version}-update-full.zip ~/FFHSR/tmp
else
  rm ~/FFHSR/tmp/*
  cp -v /home/compiler/workspace/gphone/release/${proj_name}/images/$sw_pkgs ~/FFHSR/tmp
  cp -v /home/compiler/workspace/gphone/release/${proj_name}/images/${sw_pkgs%.tar.gz}/apps.zip ~/FFHSR/tmp
  cp -v /home/compiler/workspace/gphone/release/${proj_name}/images/${sw_pkgs%.tar.gz}/${sw_version}_md5.txt ~/FFHSR/tmp
  cp -v /home/compiler/workspace/gphone/release/${proj_name}/upgrade/${sw_version##*_}/${sw_version}-update-full.zip ~/FFHSR/tmp
echo sff
fi
ls ~/FFHSR/tmp
#read -p "确认上传IMG:(enter yes)" ans
ans=`question "确认上传IMG" "1" "yes"`
if [ "$ans" = "yes" ];then
  echo "svn import ~/FFHSR/tmp http://smartphone/repositories/MSM8974IMG/PD1303LG3/SystemTest/$sw_version -m"PD1303LG3: $sw_version images upload""
  svn import ~/FFHSR/tmp http://smartphone/repositories/MSM8974IMG/PD1303LG3/SystemTest/$sw_version -m"PD1303LG3: $sw_version images upload"
fi
/usr/local/bin/backup/get-image-url.sh
