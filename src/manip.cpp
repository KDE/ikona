#include "manip.h"

QString IconManipulator::toLight(const QString& data) {
    QString manip = data;
    
    manip.replace("fill=\"#eff0f1\"", "fill=\"#232629\"");
    manip.replace("fill=\"#31363b\"", "fill=\"#eff0f1\"");
    manip.replace("fill=\"#232629\"", "fill=\"#fcfcfc\"");
    manip.replace("color:#eff0f1", "color:#232629");
    manip.replace("color:#31363b", "color:#eff0f1");
    manip.replace("color:#232629", "color:#fcfcfc");

    return manip;
}

QString IconManipulator::toDark(const QString& data) {
    QString manip = data;

    manip.replace("fill=\"#232629\"", "fill=\"#eff0f1\"");
    manip.replace("fill=\"#eff0f1\"", "fill=\"#31363b\"");
    manip.replace("fill=\"#fcfcfc\"", "fill=\"#232629\"");
    manip.replace("color:#232629", "color:#eff0f1");
    manip.replace("color:#eff0f1", "color:#31363b");
    manip.replace("color:#fcfcfc", "color:#232629");

    return manip;
}

QString IconManipulator::classIcon(const QString& data) {
    QString manip = data;

    manip.replace("fill=\"#232629\"", "class=\"ColorScheme-Text\" fill=\"currentColor\"");
    manip.replace("fill=\"#eff0f1\"", "class=\"ColorScheme-Background\" fill=\"currentColor\"");
    manip.replace("fill=\"#fcfcfc\"", "class=\"ColorScheme-ViewBackground\" fill=\"currentColor\"");
    manip.replace("fill=\"#3daee9\"", "class=\"ColorScheme-ButtonFocus\" fill=\"currentColor\"");
    manip.replace("fill=\"#27ae60\"", "class=\"ColorScheme-PositiveText\" fill=\"currentColor\"");
    manip.replace("fill=\"#f67400\"", "class=\"ColorScheme-NeutralText\" fill=\"currentColor\"");
    manip.replace("fill=\"#da4453\"", "class=\"ColorScheme-NegativeText\" fill=\"currentColor\"");

    return manip;
}