from django.shortcuts import render, redirect
from django.utils.timezone import now
from .models import Task, Tag
from .forms import TaskForm, LoginForm
from django.contrib.auth import authenticate, login


def main(request):
    model = Task.objects.all().order_by('-time').values()
    tags = Tag.objects.values().all()
    form = TaskForm()
    con = {'context': list(model), 'form': form, 'tags': list(tags)}
    if request.method == 'POST':
        form = TaskForm(request.POST)
        if form.is_valid():
            if 'tags' not in request.POST:
                copy = request.POST.copy()
                copy['tags'] = '-'
                f = form.save(commit=False)
                f.tags = copy['tags']
                f.time = now().ctime()#.__format__("%b %d %Y - %H:%M")
                form.save()
            else: 
                f = form.save(commit=False)
                f.tags = request.POST.getlist('tags')
                f.time = now().ctime()#.__format__("%b %d %Y - %H:%M")
                form.save()
        return redirect('/logbook')
    else:
        form = TaskForm()
    return render(request, "main.html", con)


def user_login(request):

    print(request.method, request.body, request.get_host(), request.get_full_path())
    
    if request.method == 'POST':
        form = LoginForm(request.POST)
        if form.is_valid():
            clean_data = form.cleaned_data
            user = authenticate(request, username=clean_data['username'], password=clean_data['password'])
            if user is None:
                return render(request, 'login.html', {'user': 'invalid user'})
            elif user.is_active:
                login(request, user)
                return main(request)
            else:
                return render(request, 'login.html', {'user': 'invalid - please check your credentials'})
    else:
        form = LoginForm()
        return render(request, 'login.html', {'login_form': form})