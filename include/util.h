#pragma once

void writeFile(const QString& path, const QString& data);
auto readFile(const QString& path) -> QString;
bool copyFile(const QString& from, const QString& to);