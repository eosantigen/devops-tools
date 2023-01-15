from .models import Task, Tag
from django import forms
from django.forms import ModelForm, ModelMultipleChoiceField, CheckboxSelectMultiple, Form


class TaskForm(ModelForm):

    class Meta:

        model = Task
        fields = ['user', 'task', 'tags']
        # template_name = 'main.html'
        
    tags = ModelMultipleChoiceField(
    queryset=Tag.objects.all(),
    widget=CheckboxSelectMultiple(), required=False,
    )

class LoginForm(Form):
    username = forms.CharField()
    password = forms.CharField(widget=forms.PasswordInput)