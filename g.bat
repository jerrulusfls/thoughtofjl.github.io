echo start generate now
call hexo clean
call hexo generate
call hexo s
call xcopy C:\Projects\blog\public C:\Projects\blog\clone /Y /E
pause