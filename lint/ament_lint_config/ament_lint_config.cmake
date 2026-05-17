# Custos shared ament_lint config.
# Add this file to a package's CMakeLists.txt before `ament_lint_auto_find_test_dependencies()`
# to opt into the project-wide style. Disables checks we substitute with
# clang-format/ruff and keeps the structural ones.

find_package(ament_cmake REQUIRED)

set(AMENT_LINT_AUTO_EXCLUDE
    ament_cmake_uncrustify       # we use clang-format instead
    ament_cmake_cpplint          # we use clang-format instead
    ament_cmake_flake8           # we use ruff instead
    ament_cmake_pep257           # we use ruff instead
)
