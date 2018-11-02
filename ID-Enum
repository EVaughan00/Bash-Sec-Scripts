echo "Users with 0 IDs"
echo
cat /etc/passwd | grep ":0:"
echo
echo
echo "Users that can login"
#if ! grep nologin /etc/passwd
echo
cat /etc/passwd | grep -w "login"
echo
echo 
echo "Sudoers file output"
cat /etc/sudoers | grep -v "#" 
echo
echo 
echo "Sudoers directory"
echo
ls -al /etc/sudoers.d

echo 
echo
echo "Which Users Should You Delete?"

read a

for i in $a
do
 userdel -r $i
 
 groupdel $i
done
