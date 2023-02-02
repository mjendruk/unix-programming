#include <apue.h>
#include <dirent.h>
#include <iostream>

int main(int argc, char *argv[]) {

  auto dp = static_cast<DIR *>(nullptr);
  auto dirp = static_cast<dirent *>(nullptr);

  if (argc != 2) {
    err_quit("usage: ls directory_name");
  }

  if ((dp = ::opendir(argv[1])) == NULL) {
    ::err_sys("can't open %s", argv[1]);
  }

  while ((dirp = readdir(dp)) != NULL) {
    ::printf("%s\n", dirp->d_name);
  }

  ::closedir(dp);
  return 0;
}
