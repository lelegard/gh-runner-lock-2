#include <mutex>
#include <iostream>
int main()
{
#if defined(_DISABLE_CONSTEXPR_MUTEX_CONSTRUCTOR)
    std::cout << "_DISABLE_CONSTEXPR_MUTEX_CONSTRUCTOR is defined" << std::flush << std::endl;
#endif
    std::cout << "1" << std::flush << std::endl;
    std::mutex m;
    std::cout << "2" << std::flush << std::endl;
    std::lock_guard<std::mutex> lock(m);
    std::cout << "3" << std::flush << std::endl;
    return EXIT_SUCCESS;
}
