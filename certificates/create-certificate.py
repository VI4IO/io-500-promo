#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import traceback
import csv
import sys

# This script generates a certificate.
# JK 2018

import sys
import os.path
from PIL import Image
from reportlab.pdfgen import canvas
from reportlab.lib.units import inch, cm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont

# We use the Arimo font
pdfmetrics.registerFont(TTFont('Arimo-Bold', 'Arimo-Bold.ttf'))
pdfmetrics.registerFont(TTFont('Arimo', 'Arimo-Regular.ttf'))

class PDFDoc():
  def __init__(self, name, width, height):
    self.dim = (width*cm, height*cm)
    self.c = canvas.Canvas(name, pagesize=self.dim)

  def newpage(self):
    self.c.showPage()

  def save(self):
    self.c.showPage()
    self.c.save()

  def findImg(self, fileimg):
    fileimg = fileimg.replace(" ", "-").lower()
    for typ in ["png", "jpg"]:
      fname = fileimg + "." + typ
      if os.path.isfile(fname):
        return fname
    return None

  def addKeyVal(self, value, posx, posy, size=0.1, font= "Arimo", color=(0,0,0)):
    if value == None or len(value) == 0:
      return
    #relative font size
    self.c.setFont(font, self.dim[1] * size)
    self.c.setStrokeColorRGB(*color)
    self.c.setFillColorRGB(*color)
    value = value.strip().split("\n")
    for l in value:
      self.c.drawCentredString(self.dim[0] * posx, self.dim[1] * posy, l)


def createCertificate(outputDir, data, institution, rank):
  data["rank"] = rank
  data["institution"] = institution

  dim = (29.7, 21.0)
  doc = PDFDoc("foreground.pdf", dim[0], dim[1])

  inst = data["institution"]
  size = 0.1

  if len(inst) > 20:
    size = 0.1 * 20 / len(inst) 

  doc.addKeyVal(inst, 0.5, 0.55, size, font="Arimo-Bold")
  doc.addKeyVal("to be ranked #" + str(data["rank"]) + " in the " + data["challenge"], 0.5, 0.48, size=0.05)

  doc.addKeyVal(data["release"], 0.7, 0.31, size=0.055, font="Arimo-Bold")
  doc.addKeyVal("http://io500.org/list/" + data["list"] + "/", 0.5, 0.03, size=0.055, font="Arimo-Bold")
  doc.save()

  from PyPDF2 import PdfFileWriter, PdfFileReader
  import io
  background = PdfFileReader(open("certificate-empty.pdf", "rb"))
  foreground = PdfFileReader(open("foreground.pdf", "rb"))
  page = background.getPage(0)
  page.mergePage(foreground.getPage(0))
  output = PdfFileWriter()
  output.addPage(page)
  outputStream = open(outputDir + "/" + str(rank) + ".pdf", "wb")
  output.write(outputStream)
  outputStream.close()

if __name__ == "__main__":
  input = sys.argv[4]
  output = sys.argv[5]

  list = {"release" : sys.argv[2],
          "list"    : sys.argv[1],
          "challenge" : sys.argv[3]}
  csvfile = open(input, 'r')
  csv = csv.DictReader(csvfile)
  # sort the systems according to their rank
  systems = [ x for x in csv]
  systems.sort(key = lambda x : -float(x["io500__score"]))

  rank = 1
  for p in systems:
    createCertificate(output, list, p["information__institution"], rank)
    rank = rank + 1
