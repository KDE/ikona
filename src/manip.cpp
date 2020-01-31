#include "manip.h"
#include "ikonars.h"
#include <QDebug>

QString toLight(const QString& data) {
    QString manip = data;
    
    manip.replace("fill=\"#eff0f1\"", "fill=\"#232629\"");
    manip.replace("fill=\"#31363b\"", "fill=\"#eff0f1\"");
    manip.replace("fill=\"#232629\"", "fill=\"#fcfcfc\"");
    manip.replace("color:#eff0f1", "color:#232629");
    manip.replace("color:#31363b", "color:#eff0f1");
    manip.replace("color:#232629", "color:#fcfcfc");

    return manip;
}

QString toDark(const QString& data) {
    QString manip = data;

    manip.replace("fill=\"#232629\"", "fill=\"#eff0f1\"");
    manip.replace("fill=\"#eff0f1\"", "fill=\"#31363b\"");
    manip.replace("fill=\"#fcfcfc\"", "fill=\"#232629\"");
    manip.replace("color:#232629", "color:#eff0f1");
    manip.replace("color:#eff0f1", "color:#31363b");
    manip.replace("color:#fcfcfc", "color:#232629");

    return manip;
}

QString classIcon(const QString& data) {
    auto dataStr = data.toStdString();
    auto dataCStr = dataStr.c_str();

    auto icon = ikona_icon_new_from_string(dataCStr);
    auto light = ikona_icon_class_as_light(icon);
    auto cdata = ikona_icon_read_to_string(light);

    QString lightString(cdata);

    return lightString;
}

QString IconManipulator::processIconInternal(const QString& inPath, IconKind type, const QString& idToExtract, int32_t targetSize) {
    auto inPathStr = inPath.toStdString();
    auto idToExtractStr = idToExtract.toStdString();

    auto inPathCStr = inPathStr.c_str();
    auto idToExtractCStr = idToExtractStr.c_str();

    auto icon = ikona_icon_new_from_path(inPathCStr);
    auto manip = ikona_icon_extract_subicon_by_id(icon, idToExtractCStr, targetSize);
    const char* manipulated = ikona_icon_read_to_string(manip);
    
    QString manipulatedString(manipulated);

    manipulatedString = classIcon(manipulatedString);

    if (type == IconKind::Dark) {
        manipulatedString = toDark(manipulatedString);
    }

    return manipulatedString;
}

// TODO: unbreak this and use it
// QString IconManipulator::extractIdFromSvg(const QString& iconData, const QString& id, const int& targetWidthHeight) {
//     auto cStr = qUtf8Printable(iconData);
//     GError* error = NULL;
//     auto handle = rsvg_handle_new_from_data((const guint8*) cStr, strlen(cStr), &error);
//     if (error != NULL) {
//         qCritical() << error->message;
//     }
//     auto procPath = qUtf8Printable("/tmp/" + QString::number(qrand() % 1000000) + "ikonaproc.svg");
    
//     if (rsvg_handle_has_sub(handle, qUtf8Printable(id))) {
//         GValue width, height = G_VALUE_INIT;
//         g_object_get_property(G_OBJECT(handle), "width", &width);
//         g_object_get_property(G_OBJECT(handle), "height", &height);
//         RsvgRectangle rect;
//         RsvgRectangle vp = {
//             .x = 0,
//             .y = 0,
//             .width = g_value_get_int(&width),
//             .height = g_value_get_int(&height)
//         };
//         rsvg_handle_get_geometry_for_layer(handle, qUtf8Printable(id), &vp, NULL, &rect, NULL);
        
//         auto surface = cairo_svg_surface_create(procPath, targetWidthHeight, targetWidthHeight);
//         cairo_svg_surface_set_document_unit(surface, CAIRO_SVG_UNIT_PX);

//         auto context = cairo_create(surface);
//         cairo_scale(context, targetWidthHeight/rect.width, targetWidthHeight/rect.height);
//         cairo_translate(context, -rect.x, -rect.y);

//         rsvg_handle_render_cairo(handle, context);

//         auto file = g_file_new_for_path(procPath);
//         auto stream = g_file_read(file, NULL, NULL);
//         if (stream == NULL) {
//             return "";
//         }
//         char* data;
//         g_input_stream_read_all(G_INPUT_STREAM(stream), data, G_MAXSIZE, NULL, NULL, NULL);

//         return QString(data);
//     }
//     return "";
// }