/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Copyright 2013 Joshua C. Klontz                                           *
 *                                                                           *
 * Licensed under the Apache License, Version 2.0 (the "License");           *
 * you may not use this file except in compliance with the License.          *
 * You may obtain a copy of the License at                                   *
 *                                                                           *
 *     http://www.apache.org/licenses/LICENSE-2.0                            *
 *                                                                           *
 * Unless required by applicable law or agreed to in writing, software       *
 * distributed under the License is distributed on an "AS IS" BASIS,         *
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  *
 * See the License for the specific language governing permissions and       *
 * limitations under the License.                                            *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#include <QtCore>
#include <QtWidgets>
#include "likely.h"

using namespace likely;

class Element : public QGraphicsRectItem
{
    const Matrix *matrix;
    likely_size c, x, y, t;

public:
    Element(const Matrix *matrix_, likely_size c_, likely_size x_, likely_size y_, likely_size t_)
        : matrix(matrix_), c(c_), x(x_), y(y_), t(t_) {}

    double element() const { return likely_element(matrix, c, x, y, t); }
};

class Dataset : public QObject
{
    Q_OBJECT
    Matrix matrix;

public slots:
    void setDataset(const QImage &image)
    {
        matrix = Matrix(3, image.width(), image.height(), 1, likely_hash_u8);
        memcpy(matrix.data, image.constBits(), matrix.bytes());
        emit newImage(image);
    }

    void setDataset(QAction *action)
    {
        setDataset(QImage(action->data().toString()).convertToFormat(QImage::Format_RGB888));
    }

signals:
    void newImage(QImage image);
};

class DatasetViewer : public QGraphicsView
{
    Q_OBJECT
    QGraphicsScene scene;
    int zoomLevel;

public:
    explicit DatasetViewer(QWidget *parent = 0)
        : QGraphicsView(parent)
    {
        scene.addText("Drag and Drop Image Here", QFont("", 24, QFont::Bold));
        zoomLevel = 0;
        setAcceptDrops(true);
        setAlignment(Qt::AlignCenter);
        setFocusPolicy(Qt::WheelFocus);
        setScene(&scene);
        setSizePolicy(QSizePolicy::Ignored, QSizePolicy::Ignored);
    }

public slots:
    void setImage(const QImage &image)
    {
    }

private slots:
    void dragEnterEvent(QDragEnterEvent *event)
    {
        event->accept();
        if (event->mimeData()->hasUrls() || event->mimeData()->hasImage())
            event->acceptProposedAction();
    }

    void dropEvent(QDropEvent *event)
    {
        event->accept();
        event->acceptProposedAction();

        const QMimeData *mimeData = event->mimeData();
        if (mimeData->hasImage()) {
            emit newDataset(qvariant_cast<QImage>(mimeData->imageData()));
        } else if (mimeData->hasUrls()) {
            foreach (const QUrl &url, mimeData->urls()) {
                if (!url.isValid()) continue;
                const QString localFile = url.toLocalFile();
                if (localFile.isNull()) continue;
                emit newDataset(QImage(localFile));
                break;
            }
        }
    }

    void keyPressEvent(QKeyEvent *event)
    {
        if (event->modifiers() != Qt::CTRL) return;
        if      (event->key() == Qt::Key_Equal) zoomLevel=qMin(zoomLevel+1, 3);
        else if (event->key() == Qt::Key_Minus) zoomLevel=qMax(zoomLevel-1, 0);
        else                                    return;
        event->accept();
    }

signals:
    void newDataset(QImage image);
};

class Engine : public QObject
{
    Q_OBJECT
    QImage input;
    int param;
    likely_unary_function function = NULL;

public:
    Engine(QObject *parent = 0)
        : QObject(parent)
    {
        setParam(0);
    }

public slots:
    void setInput(const QImage &input)
    {
        this->input = input;
        // TODO: process image and emit result
    }

    void setParam(int param)
    {
        this->param = param;
        function = likely_make_unary_function(qPrintable(QString::number(param/10.0) + "*src"));
        qDebug() << param/10.0;
        setInput(input);
    }
};

int main(int argc, char *argv[])
{
    QApplication application(argc, argv);

    Dataset *dataset = new Dataset();
    DatasetViewer *datasetViewer = new DatasetViewer();
    QObject::connect(dataset, SIGNAL(newImage(QImage)), datasetViewer, SLOT(setImage(QImage)));
    QObject::connect(datasetViewer, SIGNAL(newDataset(QImage)), dataset, SLOT(setDataset(QImage)));

    QMenu *datasetsMenu = new QMenu("Datasets");
    foreach (const QString &fileName, QDir(":/img").entryList(QDir::Files, QDir::Name)) {
        const QString filePath = ":/img/"+fileName;
        QAction *potentialDataset = new QAction(QIcon(filePath), QFileInfo(filePath).baseName(), datasetsMenu);
        potentialDataset->setData(filePath);
        potentialDataset->setShortcut(QKeySequence("Ctrl+"+fileName.mid(0, 1)));
        datasetsMenu->addAction(potentialDataset);
    }
    QObject::connect(datasetsMenu, SIGNAL(triggered(QAction*)), dataset, SLOT(setDataset(QAction*)));

    QMenuBar *menuBar = new QMenuBar();
    menuBar->addMenu(datasetsMenu);

    QSlider *slider = new QSlider(Qt::Horizontal);
    slider->setMinimum(0);
    slider->setMaximum(20);

    QVBoxLayout *centralWidgetLayout = new QVBoxLayout();
    centralWidgetLayout->addWidget(datasetViewer);
    centralWidgetLayout->addWidget(slider);

    QWidget *centralWidget = new QWidget();
    centralWidget->setLayout(centralWidgetLayout);

    Engine *engine = new Engine();
    QObject::connect(datasetViewer, SIGNAL(newDataset(QImage)), engine, SLOT(setInput(QImage)));
    QObject::connect(slider, SIGNAL(valueChanged(int)), engine, SLOT(setParam(int)));

    QMainWindow mainWindow;
    mainWindow.setCentralWidget(centralWidget);
    mainWindow.setMenuBar(menuBar);
    mainWindow.setWindowTitle("Likely Creator");
    mainWindow.resize(800,600);
    mainWindow.show();

    return application.exec();
}

#include "create.moc"
