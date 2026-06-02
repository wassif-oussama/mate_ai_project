from django.contrib import admin
from .models import Parent, Child, Story, StoryPack, Purchase, ChildLibrary, ConversationSession, DialogueTurn, ActivitySession

# On enregistre uniquement les tables qui existent actuellement dans models.py
admin.site.register(Parent)
admin.site.register(Child)
admin.site.register(Story)
admin.site.register(StoryPack)
admin.site.register(Purchase)
admin.site.register(ChildLibrary)
admin.site.register(ConversationSession)
admin.site.register(DialogueTurn)
admin.site.register(ActivitySession)