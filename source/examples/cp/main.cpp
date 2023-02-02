#include <apue.h>
#include <array>
#include <dirent.h>
#include <iostream>

#define MJ_SYSCALL(fncall)                                                     \
  [&](const char *functionName) {                                              \
    auto result = fncall;                                                      \
    if (result == -1) {                                                        \
      ::err_sys("%s: syscall failed " #fncall, functionName);                  \
    }                                                                          \
    return result;                                                             \
  }(__PRETTY_FUNCTION__)

int main(int argc, char *argv[]) {
  auto buffer = std::array<char, 4096>{};
  auto bytesRead = 0;

  while ((bytesRead = MJ_SYSCALL(
              ::read(STDIN_FILENO, buffer.data(), buffer.size()))) > 0) {
    MJ_SYSCALL(::write(STDOUT_FILENO, buffer.data(), bytesRead));
  }

  return 0;
}
