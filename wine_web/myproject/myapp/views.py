# -*- coding: utf-8 -*-
from django.shortcuts import render_to_response
from django.template import RequestContext
from django.http import HttpResponseRedirect
from django.core.urlresolvers import reverse

from myproject.myapp.models import Document
from myproject.myapp.forms import DocumentForm

import os

def list(request):
    # Handle file upload
    if request.method == 'POST':
        form = DocumentForm(request.POST, request.FILES)
        if form.is_valid():
            newdoc = Document(docfile = request.FILES['docfile'])
            newdoc.save()
            file_name = newdoc.docfile.name
            if 0 and not file_name.split('/')[1].replace('.','').isalnum():
                new_name = ''
                for c in file_name.split('/')[1]:
                    if c.isalnum() or c == '.':
                        new_name += c
                os.system('mv media/query/%s media/query/%s'%(file_name, new_name))
                with open('job', 'w') as f:
                    f.write(new_name)
                    os.system('convert media/query/%s -resize x750 media/query/%s'%(new_name, new_name))
            else:
                with open('job', 'w') as f:
                    file_name = newdoc.docfile.name.split('/')[1].encode('utf-8')
                    f.write(file_name)
                    os.system('convert media/query/%s -resize x750 media/query/%s'%(file_name, file_name))

            # Redirect to the document list after POST
            return HttpResponseRedirect(reverse('myproject.myapp.views.list'))
    else:
        form = DocumentForm() # A empty, unbound form

    # Load documents for the list page
    documents = Document.objects.all()
    
    with open('job') as f:
        file_name = f.read()
    done = 0
    if file_name.strip() != 'nojob':
        while done == 0:
            try:
                with open('media/result/'+file_name.decode('utf-8')+'txt') as f:
                    t = f.read()
                    if not t:
                        raise Exception
                with open('job', 'w') as f:
                    f.write('nojob')
                done = 1
            except Exception as e:
                done = 0
    else:
        file_name = []
        done = 0

    # Render list page with the documents and the form
    return render_to_response(
        'list.html',
        {'file_name': file_name, 'form': form, 'done': done},
        context_instance=RequestContext(request)
    )
